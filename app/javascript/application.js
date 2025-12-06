// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Menú responsive (toggle) — robust init for Turbo & initial load
function setupMenuToggle() {
	const btn = document.getElementById("menu-btn");
	const menu = document.getElementById("mobile-menu");
	if (!btn || !menu) return;

	// Avoid duplicate event bindings across Turbo renders
	if (btn.dataset.bound === "true") return;
	btn.dataset.bound = "true";

	btn.addEventListener("click", () => {
		menu.classList.toggle("hidden");
		const expanded = btn.getAttribute("aria-expanded") === "true";
		btn.setAttribute("aria-expanded", (!expanded).toString());
	});
}

document.addEventListener("turbo:load", setupMenuToggle);
document.addEventListener("DOMContentLoaded", setupMenuToggle);
