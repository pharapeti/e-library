class BookDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegators :@view, :check_box_tag, :link_to, :mail_to, :edit_user_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      title: { source: 'Book.title', cond: :like, searchable: true, orderable: true },
      author: { source: 'Book.author', cond: :like, searchable: true, orderable: true },
      book_type: { source: 'Book.book_type', cond: :like, searchable: true, orderable: true },
      edition: { source: 'Book.edition' },
      reference_number: { source: 'Book.reference_number' },
      copies_available: { source: 'Book.reference_number' }, # stubbed, don't touch
      active: { source: 'Book.active' }, # stubbed, don't touch
    }
  end

  def data
    records.map do |record|
      {
        DT_RowId: record.id,
        title: record.title,
        author: record.author,
        book_type: record.book_type,
        edition: record.edition,
        reference_number: record.reference_number,
        copies_available: record.copies_available,
        active: record.active,
        show: link_to('Show', "/books/#{record.id}")
      }
    end
  end

  def get_raw_records
    Book.all
  end
end
