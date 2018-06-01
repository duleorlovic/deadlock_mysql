# rubocop:disable Metrics/BlockLength
# rubocop:disable Metrics/LineLength
DEFAULT_SLEEP = 1
namespace :demo do
  task :find_in_transaction, %i[name sleep] => :environment do |_task, args|
    name = args.name
    sleep = args.sleep || DEFAULT_SLEEP
    raise 'Please provide name' if name.blank?
    Farmer.transaction do
      farmer = Farmer.find_by! name: name
      Rails.logger.info "done find_by! and start sleep #{sleep} for #{farmer.name}"
      sleep sleep.to_i
      Rails.logger.info "end sleep #{sleep} for #{farmer.name}"
    end
  end

  task :find_in_lock_and_transaction, %i[name sleep] => :environment do |_task, args|
    name = args.name
    sleep = args.sleep || DEFAULT_SLEEP
    raise 'Please provide name' if name.blank?
    Rails.logger.info 'start'
    Farmer.transaction do
      farmer = Farmer.lock.find_by! name: name
      Rails.logger.info "done lock.find_by! and start sleep #{sleep} for #{farmer.name}"
      sleep sleep.to_i
      Rails.logger.info "end sleeping #{sleep} for #{farmer.name}"
    end
  end

  task :destroy_in_transaction, %i[name sleep_before sleep_after] => :environment do |_task, args|
    name = args.name
    sleep_before = args.sleep_before || DEFAULT_SLEEP
    sleep_after = args.sleep_after || DEFAULT_SLEEP
    raise 'Please provide name' if name.blank?
    Farmer.transaction do
      farmer = Farmer.find_by! name: name
      Rails.logger.info "start sleep_before #{sleep_before} for #{farmer.name}"
      sleep sleep_before.to_i
      farmer.destroy!
      Rails.logger.info "start sleep_after #{sleep_after} for #{farmer.name}"
      sleep sleep_after.to_i
      Rails.logger.info "end sleep_after #{sleep_after} for #{farmer.name}"
    end
  end
end
