// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Menú responsive (toggle)
document.addEventListener("turbo:load", () => {
	const btn = document.getElementById("menu-btn");
	const menu = document.getElementById("mobile-menu");

	if (btn && menu) {
		btn.addEventListener("click", () => {
			menu.classList.toggle("hidden");
		});
	}
});
