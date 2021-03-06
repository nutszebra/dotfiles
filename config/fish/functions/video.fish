function video2png -d "Simple ffmpeg wrapper"
    set --local filename $argv[1]
    set --local extension (echo $argv[1] | awk -F. '{print $NF}')
    set --local filename (basename $argv[1] .$extension)
    mkdir -p $filename
    pushd $filename
    echo $filename
    ffmpeg  -i ../$argv[1] -r 5 -f image2 "$filename"_%06d.png -q:v 1
    popd
end

function video2mp4 -d "convert video to mp4 format"
    set --local filename $argv[1]
    set --local extension (echo $argv[1] | awk -F. '{print $NF}')
    set --local filename (basename $argv[1] .$extension)
    ffmpeg -i $argv[1] -c:v copy -c:a aac -strict experimental -b:a 128k "$filename".mp4
end

function video-split -d "split video"
    ffmpeg -i $argv[1] -ss $argv[2] -t $argv[3] splited-"$argv[1]"
end
