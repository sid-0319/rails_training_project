# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == params[:sort] && params[:direction] == 'asc' ? 'desc' : 'asc'
    link_to title, request.params.merge(sort: column, direction: direction, page: nil)
  end
end
