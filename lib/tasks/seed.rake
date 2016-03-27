require 'pg'
require 'thread'

namespace :seed do
  desc "TODO"
  task ips: :environment do
    # def public_ip_addresses
    #   all_ips = ip_range('0.0.0.0', '255.255.255.255')
    #   class_a_ips = ip_range('10.0.0.0', '10.255.255.255')
    #   class_b_ips = ip_range('172.16.0.0', '172.31.255.255')
    #   class_c_ips = ip_range('192.168.0.0', '192.168.255.255')

    #   all_ips.lazy.reject do |ip_addr|
    #     ip_addr.between?(class_a_ips.first, class_a_ips.last) ||
    #     ip_addr.between?(class_b_ips.first, class_b_ips.last) ||
    #     ip_addr.between?(class_c_ips.first, class_c_ips.last)
    #   end
    # end

    # def ip_range(start_ip, end_ip)
    #   (IPAddr.new(start_ip)..IPAddr.new(end_ip))
    # end

    queue = Queue.new

    (0..(2 ** 32 - 1)).step((2 ** 32 - 1) / 10000.0).each_cons(2) do |lower, upper|
      queue << [lower.floor, upper.ceil]
    end

    threads = Array.new(100) do
      Thread.new do
        until queue.empty? do
          lower, upper = queue.pop

          puts "lower: #{lower}, upper: #{upper}"

          ActiveRecord::Base.connection.execute("
            INSERT INTO proxies (host, port, created_at, updated_at)
            SELECT '0.0.0.0'::inet + i, 8080, NOW(), NOW()
            FROM generate_series(#{lower}, #{upper}, 1) AS i
            ON CONFLICT DO NOTHING;
          ")
        end
      end
    end

    threads.each(&:join)
  end
end
