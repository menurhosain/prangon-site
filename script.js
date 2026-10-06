// Each clip shows a still frame until clicked. Only then is the video
// requested, so the page loads with images alone.
document.querySelectorAll(".clip__btn").forEach((btn) => {
  btn.addEventListener("click", () => {
    const video = document.createElement("video");
    video.src = btn.dataset.src;
    video.poster = btn.querySelector("img").src;
    video.controls = true;
    video.playsInline = true;
    video.setAttribute("aria-label", btn.getAttribute("aria-label").replace(/^Play /, ""));
    btn.replaceWith(video);
    video.play().catch(() => {});
    video.focus();
  });
});

// Keep one video playing at a time.
document.addEventListener("play", (event) => {
  document.querySelectorAll(".clip video").forEach((v) => {
    if (v !== event.target) v.pause();
  });
}, true);
