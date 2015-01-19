# encoding: utf-8

class Product < ActiveRecord::Base
  # подключаем концерн для того, чтобы запись помечалась, как удаленная,
  # а не удалялась. Только нужно добавить поле deleted_at в эту модель
  include Archivable

  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  validates :title, :description, :image_url, presence: {message: 'не может быть пустым'}
  validates :title, length: { minimum: 4, message: 'должен быть минимум 4 символа' }
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: { with: /\.(gif|jpg|png)\z/i,
    message: "Изображение должно иметь расширение gif, jpg или png." }
  
  private

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'существуют товарные позиции')
      return false
    end
  end
end