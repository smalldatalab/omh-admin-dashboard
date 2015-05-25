class MobilityDashboard < ActiveRecord::Base
  def user_record
    gmail = self.gmail.gsub(/\s+/, "").downcase
    if PamUser.where('email_address' => {'address' => gmail}).blank?
      return nil
    else
      return PamUser.find_by('email_address' => {'address' => gmail})
    end
  end

end