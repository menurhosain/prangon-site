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

// Mobile menu: full-screen panel toggled by the Menu tag.
const topbar = document.querySelector(".topbar");
const menuBtn = document.querySelector(".menu-btn");

function setMenu(open) {
  topbar.classList.toggle("is-open", open);
  document.body.classList.toggle("menu-open", open);
  menuBtn.setAttribute("aria-expanded", String(open));
  menuBtn.textContent = open ? "Close" : "Menu";
}

menuBtn.addEventListener("click", () => {
  setMenu(menuBtn.getAttribute("aria-expanded") !== "true");
});

topbar.querySelectorAll(".topbar__nav a").forEach((link) => {
  link.addEventListener("click", () => setMenu(false));
});

document.addEventListener("keydown", (event) => {
  if (event.key === "Escape" && topbar.classList.contains("is-open")) {
    setMenu(false);
    menuBtn.focus();
  }
});

// Leaving phone width with the menu open would leave the page scroll-locked.
matchMedia("(max-width: 600px)").addEventListener("change", (event) => {
  if (!event.matches) setMenu(false);
});
