//
//  MainModel.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import Foundation

struct Product: Identifiable, Codable {
    let id: String
    let lineId: Int
    let categoryCode: String
    let modalityId: Int
    let relevance: Int
    let mainWeeklyPayment: Int
    let mainTerm: Int
    let creditAvailable: Bool
    let weeklyPayments: [WeeklyPayment]
    let name: String
    let images: [String]
    let regularPrice: Double
    let finalPrice: Double

    enum CodingKeys: String, CodingKey {
        case id
        case lineId = "idLinea"
        case categoryCode = "codigoCategoria"
        case modalityId = "idModalidad"
        case relevance = "relevancia"
        case mainWeeklyPayment = "pagoSemanalPrincipal"
        case mainTerm = "plazoPrincipal"
        case creditAvailable = "disponibleCredito"
        case weeklyPayments = "abonosSemanales"
        case name = "nombre"
        case images = "urlImagenes"
        case regularPrice = "precioRegular"
        case finalPrice = "precioFinal"
    }
    // Inicializador personalizado para pruebas
        init(id: String,
             lineId: Int = 0,
             categoryCode: String = "",
             modalityId: Int = 0,
             relevance: Int = 0,
             mainWeeklyPayment: Int = 0,
             mainTerm: Int = 0,
             creditAvailable: Bool = false,
             weeklyPayments: [WeeklyPayment] = [],
             name: String,
             images: [String] = [],
             regularPrice: Double = 0.0,
             finalPrice: Double) {
            self.id = id
            self.lineId = lineId
            self.categoryCode = categoryCode
            self.modalityId = modalityId
            self.relevance = relevance
            self.mainWeeklyPayment = mainWeeklyPayment
            self.mainTerm = mainTerm
            self.creditAvailable = creditAvailable
            self.weeklyPayments = weeklyPayments
            self.name = name
            self.images = images
            self.regularPrice = regularPrice
            self.finalPrice = finalPrice
        }
}

struct WeeklyPayment: Codable {
    let term: Int
    let paymentAmount: Int
    let price: Double

    enum CodingKeys: String, CodingKey {
        case term = "plazo"
        case paymentAmount = "montoAbono"
        case price = "precio"
    }
}

struct APIResponse: Codable {
    let message: String
    let warning: String
    let result: ResultData

    enum CodingKeys: String, CodingKey {
        case message = "mensaje"
        case warning = "advertencia"
        case result = "resultado"
    }
}

struct ResultData: Codable {
    let products: [Product]

    enum CodingKeys: String, CodingKey {
        case products = "productos"
    }
}

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}
