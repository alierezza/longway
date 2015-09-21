class AddAttachmentBannerToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.attachment :banner
    end
  end

  def self.down
    remove_attachment :images, :banner
  end
end
