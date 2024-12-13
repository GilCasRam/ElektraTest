//
//  PersistenceController.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import Foundation
import CoreData

protocol ProductRepositoryProtocol {
    func saveProduct(product: Product)
    func isProductAlreadySaved(productId: String) -> Bool
    func fetchSavedProducts() -> [ProductEntity]
    func deleteProduct(_ product: ProductEntity)
}


class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "ProductModel") // Nombre del modelo
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error al cargar Core Data: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
}

class ProductCoreDataManager: ProductRepositoryProtocol {
    static let shared = ProductCoreDataManager()
    private let context = PersistenceController.shared.context
    
    // Guardar un producto
    func saveProduct(product: Product) {
        if isProductAlreadySaved(productId: product.id) {
            print("El producto ya está guardado.")
            return
        }
        
        let productEntity = ProductEntity(context: context)
        productEntity.id = product.id
        productEntity.name = product.name
        productEntity.finalPrice = product.finalPrice
        productEntity.imageURL = product.images.first ?? ""
        
        do {
            try context.save()
            print("Producto guardado exitosamente.")
        } catch {
            print("Error al guardar el producto: \(error.localizedDescription)")
        }
    }
    
    // Verificar si un producto ya está guardado
    func isProductAlreadySaved(productId: String) -> Bool {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", productId)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error al verificar si el producto está guardado: \(error.localizedDescription)")
            return false
        }
    }
    
    // Obtener todos los productos guardados
    func fetchSavedProducts() -> [ProductEntity] {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error al obtener productos guardados: \(error.localizedDescription)")
            return []
        }
    }
    
    // Eliminar un producto específico
    func deleteProduct(_ product: ProductEntity) {
        context.delete(product)
        do {
            try context.save()
        } catch {
            print("Error al eliminar el producto: \(error.localizedDescription)")
        }
    }
}
