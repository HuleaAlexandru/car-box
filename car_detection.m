close all;
clear all;

dirname = 'images';
files = dir(dirname);

for i=1:length(files)
  filename = files(i).name;
  path = sprintf('%s/%s', dirname, filename);
  
  try
    img = imread(path);
  catch
    % sdisplay(sprintf('invalid image filename %s\n', path));
    continue;
  end
  
  draw_car_box(img, 200,100);
      
  break;
end
