class SeedIpRange
  include Sidekiq::Worker

  def perform(lower, upper)
    ActiveRecord::Base.connection.execute("
      INSERT INTO proxies (host, port, created_at, updated_at)
      SELECT '0.0.0.0'::inet + i, 8080, NOW(), NOW()
      FROM generate_series(#{lower}, #{upper}, 1) AS i
      ON CONFLICT DO NOTHING;
    ")
  end
end