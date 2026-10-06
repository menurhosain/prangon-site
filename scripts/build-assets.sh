#!/usr/bin/env bash
# Builds web-optimized copies of the original work into ./assets.
# Originals are only read, never modified or removed.
set -euo pipefail
cd "$(dirname "$0")/.."

DOC="1. A minute, Documented"
THUMB="2. Thumb - Some"
JAARDO="3. Project Jaardo _ Creative Direction - Content - Editing"
ART="4. আর্ট-ফার্ট, illustrator. (2018–20) Made entirely with fingers and a phone"
MEME="5. 20 days - 30K likes (2020), Memes - Page Growth"

mkdir -p assets/img assets/poster assets/video

# image <src> <out name> <max px>
image() {
  magick "$1" -auto-orient -resize "${3}x${3}>" -strip -quality 80 "assets/img/$2.webp"
}

# video <src> <out name> <poster second> <max width> [crop filter]
# Poster: one frame as webp. Video: H.264 + AAC, faststart, loaded only on click.
video() {
  local src="$1" name="$2" at="$3" w="$4" pre="${5:+$5,}"
  ffmpeg -nostdin -v error -y -ss "$at" -i "$src" -frames:v 1 \
    -vf "${pre}scale='min($w,iw)':-2" -quality 78 "assets/poster/$name.webp"
  [[ -f "assets/video/$name.mp4" ]] && return
  ffmpeg -nostdin -v error -y -i "$src" -map 0:v:0 -map 0:a:0? \
    -vf "${pre}scale='min($w,iw)':-2" -c:v libx264 -preset slow -crf 25 -maxrate 2500k -bufsize 5000k -pix_fmt yuv420p \
    -c:a aac -b:a 128k -movflags +faststart "assets/video/$name.mp4"
}

# Images
image IMG_4154.jpeg headshot 1200
image "$THUMB/Artboard 1.jpg" thumb-satyajit 1280
image "$THUMB/mourinho.jpg" thumb-mourinho 1280
image "$THUMB/robinfronath fina.jpg" thumb-tagore 1280
image "$JAARDO/New Project.jpg" jaardo-diptych 1400
image "$JAARDO/Screenshot_609.png" jaardo-grid 996
image "$ART/Dinho.jpg" art-dinho 1000
image "$ART/face.jpg" art-face 1000
image "$ART/42o.jpg" art-420 1280
image "$ART/Baker Bhai.jpg" art-baker-bhai 1280
image "$ART/marzuk.jpg" art-marzuk 1280
image "$MEME/IMG_4112.jpeg" meme-page 1000

# Videos
video "$DOC/ElevenLabs_2026-08-27T19_31_58_Yair - Clear, Friendly, Expressive_pvc_sp100_s50_sb75_v3_2.mp4" doc-mourinho 8 1280
video "$JAARDO/perfect for post.mov" jaardo-signboard 24 720
video "$JAARDO/post 2 full and final done 2.mov" jaardo-lookbook 5 720
video "$JAARDO/0521(1)_3_1_3.mp4" jaardo-plaid 1 720
video "$JAARDO/Untitled pro 2 3 done.mp4" jaardo-carrom 5 1280
video "$JAARDO/CTP01032-14_1.mp4" jaardo-paperboat 3 1280 crop=1620:1080:150:0
video "$JAARDO/cha 3_8.mp4" jaardo-lantern 9 720
video "$JAARDO/835373_preview_2.mp4" jaardo-callouts 1 720
video "$JAARDO/pro2 1st.mov" jaardo-fabric 3 720
video "$JAARDO/Form III — Chapter 01Golapi camp-collar shirt featuring symmetrical floral embroidery inspired b.mp4" jaardo-form3 2.5 720
video "$MEME/AQPlKinngH1cjVhSM6R9stnKiazIQjLQw4QfLpA4T0rSbJkF7EOFYqi3rDtikJtRAXxQUH_8jtSyvOS2ezGDuFlO5_PL1E9fcFapdn5z_Zg5mQ.mp4" meme-gta-intro 21 1280
video "$MEME/@r07qxo - R⤓Download.mov" meme-natok-titles 2 400

du -sh assets/*
