import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    userId: Number
  }

  connect() {
    if (this.userIdValue) {
      this.subscription = this.setupSubscription()
    }
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
  }

  setupSubscription() {
    return App.cable.subscriptions.create(
      { channel: "NotificationsChannel" },
      {
        connected: () => {
          console.log("Notificaciones conectadas")
        },
        disconnected: () => {
          console.log("Notificaciones desconectadas")
        },
        received: (data) => {
          this.handleNotification(data)
        }
      }
    )
  }

  handleNotification(data) {
    const { action, data: notificationData } = data

    switch (action) {
      case "new_notification":
        this.showNotification(notificationData)
        this.updateNotificationBadge()
        break
      case "notification_read":
        this.removeNotificationHighlight(notificationData.notification_id)
        break
      default:
        break
    }
  }

  showNotification(notification) {
    // Crear elemento de notificación animado
    const notificationDiv = document.createElement("div")
    notificationDiv.className = 
      "fixed top-4 right-4 bg-white rounded-lg shadow-lg p-4 max-w-md z-50 animate-slide-in"
    notificationDiv.innerHTML = `
      <div class="flex items-start gap-3">
        <div class="flex-1">
          <h3 class="font-bold text-gray-900">${this.escapeHtml(notification.title)}</h3>
          <p class="text-sm text-gray-600 mt-1">${this.escapeHtml(notification.message)}</p>
        </div>
        <button type="button" class="text-gray-400 hover:text-gray-600" onclick="this.parentElement.parentElement.remove()">
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
            <path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="2"/>
          </svg>
        </button>
      </div>
    `
    
    document.body.appendChild(notificationDiv)
    
    // Auto-remove después de 5 segundos
    setTimeout(() => {
      notificationDiv.classList.add("animate-slide-out")
      setTimeout(() => notificationDiv.remove(), 300)
    }, 5000)
  }

  updateNotificationBadge() {
    // Obtener el conteo de notificaciones sin leer
    fetch("/notifications/unread_count")
      .then(response => response.json())
      .then(data => {
        const badge = document.getElementById("notification-badge")
        if (badge) {
          badge.textContent = data.count
          if (data.count > 0) {
            badge.classList.remove("hidden")
          } else {
            badge.classList.add("hidden")
          }
        }
      })
  }

  removeNotificationHighlight(notificationId) {
    const element = document.querySelector(`[data-notification-id="${notificationId}"]`)
    if (element) {
      element.classList.remove("bg-blue-50")
    }
  }

  escapeHtml(text) {
    const map = {
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      '"': "&quot;",
      "'": "&#039;"
    }
    return text.replace(/[&<>"']/g, m => map[m])
  }
}
