class PublicController < ApplicationController
  def index
    # Home page i.e. the first page encountered when the site is loaded 
    @categories = Category.sort_by_ancestry(Category.paginate(:page => params[:page]).all)
    @tags = Tag.order("(select count(*) from post_tags where tag_id = tags.id) DESC").limit(10)
    @recent_problems = Post.order("posts.updated_at DESC").limit(10)

  end
  
  def search
    # require 'rubygems'
    # require 'indextank'
    
    # Obtain an IndexTank client
    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'] || 'http://:FnQdFRnOqQkaLm@ya1a.api.searchify.com')
    index = client.indexes('idx')
    
    begin
        # Search the index
        results = index.search(params[:query])
    
        print "#{results['matches']} documents found\\n"
        results['results'].each { |doc|
          print "docid: #{doc['docid']}\\n"
        }
    rescue
        print "Error: ",$!,"\\n"
    end
  end
  
  def build_index
    # Obtain an IndexTank client
    client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'] || 'http://:FnQdFRnOqQkaLm@ya1a.api.searchify.com')
    index = client.indexes('idx')
    begin
      # Index posts
      posts = Post.all
      posts.each do |post|
        # gather error messages for the post
        error_message_text = ""
        post.error_messages.each do |e|
          error_message_text += e + " "
        end
        # gather categories for the post
        category_text = ""
        post.categories.each do |c|
          category_text += c + " "
        end
        # gather tags for the post
        tag_text = ""
        post.tags.each do |t|
          tag_text += t + " "
        end
        index.document(post.id.to_s).add({ :text => post.title + " " + post.description })
      end
      flash[:notice] = "Index Successful"
      redirect_to(:action => 'index')
      # @categories = Category.all
      # @tags = Tag.all
      # @error_messages = ErrorMessage.all
      # @solutions = Solution.all
      # @comments = Comment.all
#       
      # index.document("1").add({ :text => "some text here" })
      # index.document("2").add({ :text => "some other text" })
      # index.document("3").add({ :text => "something else here" })
    rescue
      flash[:notice] = "Indexing Failed"
      redirect_to(:action => 'index')
    end
  end
end
