# frozen_string_literal: true

require 'date'
require 'json'
require 'net/http'
require 'csv'

endpoints = %w[
  https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-glacier-flexibleretrieval.json
  https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-standard.json
  https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3.json
  https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-intelligent-tiering.json
  https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-glacier-instantretrieval.json
  https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3glacierdeeparchive/USD/current/s3glacierdeeparchive.json
  https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-standard-infrequent.json
  https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/s3/USD/current/s3-onezone-infrequent.json
  https://b0.p.awsstatic.com/pricing/2.0/meteredUnitMaps/glacier/USD/current/glacier.json
]

def get_json(url)
  puts url
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  http.use_ssl = true
  response = http.request(request)
  return JSON.parse(response.body, symbolize_names: true)
end

def export_csv(all_region_price_array, endpoint)
  tier_name = File.basename(endpoint, '.json')
  puts "Exporting data for #{tier_name}"
  first_region_keys = all_region_price_array.first[:data].map { |d| d[:rate_name] }
  result_file_name = "aws_s3_cost_#{tier_name}_#{Time.now.strftime('%Y-%m-%dT%H_%M_%S')}.csv"
  CSV.open(result_file_name, "wb", headers: %w[region_name region_code] + first_region_keys, write_headers: true) do |csv|
    all_region_price_array.each do |region_price|
      puts "Warning: Region #{region_price[:region_name]} has different keys than first region!" if region_price[:data].map { |d| d[:rate_name] } != first_region_keys
      csv<<[region_price[:region_name], get_region_code(region_price[:region_name])] + region_price[:data].map { |d| d[:price] }
    end
  end
end

REGIONS = get_json('https://b0.p.awsstatic.com/locations/1.0/aws/current/locations.json')

def get_region_code(region_name)
  region = REGIONS[region_name.to_sym]
  return nil if region.nil?
  return region[:code]
end

def process_endpoints(endpoints)
  endpoints.each do |endpoint|
    all_region_price_array = []
    cost_data = get_json(endpoint)
    cost_data[:regions].each do |region_cost_data|
      region_name = region_cost_data[0].to_s
      price_array = []
      region_cost_data[1].each do |key, value|
        price_array.append({rate_name: key.to_s, price: value[:price]})
      end
      all_region_price_array.append({region_name: region_name, data: price_array})
    end
    export_csv(all_region_price_array, endpoint)
  end
end

process_endpoints(endpoints)

puts "Done"
