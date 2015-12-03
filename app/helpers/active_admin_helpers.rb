module ActiveAdminHelpers
  def self.included(dsl)
    # nothing ...
  end

  # Returns array of hashes for csv report
  def fetch_report(sprint_id)
    response = DailyRation.includes(:dish)
      .where(sprint_id: sprint_id).group(:dish).sum(:quantity)

    report = []
    response.each do |key, value|
      key = key.as_json(except: [:id, :sort_order, :type, :created_at,
                                 :updated_at, :description, :children_ids,
                                 :category_id])
      key[:quantity] = value
      key[:total_price] = key['price'] * value
      report << key
    end

    report
  end

  # Generates csv report from custom array of hashes
  def generate_report(array)
    attributes = %w{title price quantity total_price}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      array.each do |hash|
        csv << hash.values
      end
    end
  end
end
