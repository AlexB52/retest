module Web::Controllers::Books
  class Index
    include Web::Action

    expose :books

    def call(params)
      @books = BookRepository.new.all
    end
  end
end
