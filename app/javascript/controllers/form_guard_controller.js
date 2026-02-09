import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-guard"
export default class extends Controller {
  static targets = ["form"]
  
  connect() {
    this.hasChanges = false
    this.formTarget.addEventListener("input", () => {
      this.hasChanges = true
    })
    
    // Warn before leaving page if form has changes
    window.addEventListener("beforeunload", this.confirmLeave.bind(this))
  }

  disconnect() {
    window.removeEventListener("beforeunload", this.confirmLeave.bind(this))
  }

  confirmLeave(event) {
    if (this.hasChanges) {
      event.preventDefault()
      event.returnValue = "" // Required for Chrome
    }
  }

  // Handle Cancel button click
  confirmCancel(event) {
    if (this.hasChanges) {
      if (!confirm("You have unsaved changes. Are you sure you want to leave?")) {
        event.preventDefault()
      }
    }
  }

  // Mark form as saved when submitting
  submitForm() {
    this.hasChanges = false
  }
}
