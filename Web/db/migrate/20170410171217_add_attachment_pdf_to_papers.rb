class AddAttachmentPdfToPapers < ActiveRecord::Migration
  def self.up
    change_table :papers do |t|
      t.attachment :pdf
    end
  end

  def self.down
    remove_attachment :papers, :pdf
  end
end
