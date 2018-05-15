module StoresHelper

  def select_zipcode
    @zip = []
    SatZipcode.all.limit(800).collect{ |p| [p.zipcode, p.id] }.each do |o|
      @zip << o
    end
    @zip
  end
end
