import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="cupos"
export default class extends Controller {
  static targets = ["input", "warning"];
  static values = { inscritos: Number };

  connect() {
    this.check();
    this.inputTarget.addEventListener("input", () => this.check());
  }

  check() {
    const inscritos = this.inscritosValue || 0;
    const val = parseInt(this.inputTarget.value, 10);
    if (!isNaN(val) && val < inscritos) {
      this.warningTarget.textContent = `Aviso: no puede ser menor que los inscritos (${inscritos}).`;
      this.warningTarget.classList.remove("hidden");
      this.warningTarget.classList.remove("text-green-600");
      this.warningTarget.classList.add("text-red-600");
      this.inputTarget.classList.add("border-red-500", "focus:border-red-500", "focus:ring-red-500");
    } else {
      this.warningTarget.textContent = "";
      this.warningTarget.classList.add("hidden");
      this.inputTarget.classList.remove("border-red-500", "focus:border-red-500", "focus:ring-red-500");
    }
  }
}
