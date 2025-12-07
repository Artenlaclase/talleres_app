import { Controller } from "@hotwired/stimulus"

// data-controller="flash" data-flash-timeout-value="4000"
export default class extends Controller {
  static values = { timeout: { type: Number, default: 4000 } }

  connect() {
    this._timer = setTimeout(() => this.dismiss(), this.timeoutValue)
  }

  disconnect() {
    if (this._timer) clearTimeout(this._timer)
  }

  dismiss() {
    // Add a small fade-out then remove
    this.element.classList.add("opacity-0", "transition-opacity", "duration-300")
    setTimeout(() => this.element.remove(), 300)
  }
}
