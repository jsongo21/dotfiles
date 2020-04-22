#!bin/bash/

for i in .*rc; do
  ln -sf "$(pwd)/$i" ~/$i
done
