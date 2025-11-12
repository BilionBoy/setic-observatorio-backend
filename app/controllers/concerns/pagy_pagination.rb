module PagyPagination
  extend ActiveSupport::Concern

  def paginate(query, per_page)
    pagy, paged = pagy(query, items: per_page)
    {
      pagy: {
        current_page: pagy.page,
        total_pages:  pagy.pages,
        total_count:  pagy.count,
        per_page:     pagy.items
      },
      items: paged
    }
  end
end
