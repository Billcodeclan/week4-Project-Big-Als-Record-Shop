require_relative( '../db/sql_runner' )
require_relative('./artist')
require_relative('./genre')


class Album

  attr_reader( :title, :artist_id, :quantity, :genre_id, :id, :stock_level, :buy_price, :sell_price, :mark_up, :artwork )

  def initialize( options )
    return if options == nil
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @artist_id = options['artist_id'].to_i
    @genre_id = options['genre_id'].to_i
    @quantity = options['quantity'].to_i
    @buy_price = options['buy_price'].to_f
    @sell_price = options['sell_price'].to_f
    #@artwork = "/images/album_covers/" + options['artwork'] +".jpg"
    @artwork = options['artwork']
  end

    # @artwork = options['artwork']


  def save()
    sql = "INSERT INTO albums (
    title, artist_id, genre_id, quantity, buy_price, sell_price, artwork
    ) VALUES (
      '#{ @title }', '#{ @artist_id }', '#{ @genre_id }', #{ @quantity}, #{ @buy_price}, #{ @sell_price}, '#{ @artwork}'
    ) RETURNING *"
    result = SqlRunner.run(sql)
    id = result.first['id']
    @id = id
  end

  def stock_level
    level = ""
    if @quantity > 10
      level = "High"
    elsif @quantity > 3
      level = "Medium"
    elsif @quantity > 0 && @quantity < 4 
      level = "Low"
    else
      level = "No Stock Found"
    end
  end

  def getProperColor()
    if (@quantity > 0 && @quantity < 4)
      return 'Red';
    elsif (@quantity >= 3 && @quantity <= 10)
      return 'Orange';
    elsif (@quantity >= 10)
      return 'Green';
    end
  end
  
  def mark_up
      mark_up = ((sell_price/buy_price) - 1) * 100
  end

  def artist
      sql = "SELECT * FROM artists WHERE id = #{@artist_id}"
      result = SqlRunner.run(sql)
      return Artist.new(result.first)
  end

  def genre
      sql = "SELECT * FROM genres WHERE id = #{@genre_id}"
      result = SqlRunner.run(sql)
      return Genre.new(result.first)
  end

  def self.all
    sql = "SELECT * FROM albums"
    albums = map_albums(sql)
    return albums
  end

  def self.map_albums(sql)
    albums = SqlRunner.run(sql)
    return albums.map {|album| Album.new(album)}.sort_by {|album| album.title}
  end

  # def self.find(id)     Not required in project spec but was added for possible additions
  #   sql = " SELECT * FROM albums WHERE id=#{id}"
  #   results = SqlRunner.run(sql)
  #   return Album.new( results.first)
  # end

  def self.delete_all
    sql = "DELETE FROM albums"
    SqlRunner.run( sql )
  end

 end 