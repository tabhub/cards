require 'json'
require 'fastimage'

manifest_file = './manifest.json'
manifest = JSON.parse(File.read(manifest_file))
manifest['items'] = []

url_fmt = 'https://raw.githubusercontent.com/tabhub/cards/master/languages/english/quotes/images/%s.jpg'

def get_image_size(f)
  w, h = FastImage.size(f)
  ratio = (h / w.to_f).round(3)
  top = 70
  if w > 500
    width_base = 470
  else
    width_base = w
  end
  top += (500 - h) / 2 if h < 500
  if w == h
    sprintf("%spx*%spx*%spx", width_base, width_base, top)
  else
    height = width_base * ratio
    sprintf("%spx*%spx*%spx", width_base, height.ceil, top)
  end
end

Dir["./images/*.jpg"].each do |f|
  image_size = get_image_size(f)
  name = File.basename(f, '.jpg')
  manifest['items'] << { name: name, type: 'image', image_style: image_size, url: sprintf(url_fmt, name) }
end

File.write(manifest_file, JSON.pretty_generate(manifest))
