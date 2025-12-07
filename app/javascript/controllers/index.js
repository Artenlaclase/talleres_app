// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Ensure menu controller is registered explicitly
import MenuController from "controllers/menu_controller"
application.register("menu", MenuController)

// Explicit flash controller registration
import FlashController from "controllers/flash_controller"
application.register("flash", FlashController)

// Cupos live validation controller
import CuposController from "controllers/cupos_controller"
application.register("cupos", CuposController)
