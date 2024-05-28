//
//  File.swift
//  
//
//  Created by Enrico Maricar on 28/05/24.
//

import Foundation
import RxSwift
import Core

public class DetailViewModel : ObservableObject {
    @Published var gameDetail: GameDetail?
//    @Published var gameLocal: Game?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavorite: Bool = false
    private let disposeBag: DisposeBag = DisposeBag()
    private final let appRepository : AppRepository
    public init(appRepository : AppRepository) {
        self.appRepository = appRepository
    }
    
    public func loadGameDetail(for id: Int) {
        isLoading = true
        appRepository.fetchGameDetail(id: id)
            .subscribe(
                onNext: { [weak self] detail in
                    self?.gameDetail = detail
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                },
                onCompleted: { [weak self] in
                    self?.isLoading = false
                }
            ).disposed(by: disposeBag)
    }
    
    public func loadGameDetailLocal(for id: Int) {
        isLoading = true
        appRepository.fetchGameDetailLocal(id: id)
            .subscribe(
                onNext: { [weak self] game in
                    self?.gameDetail = game
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                },
                onCompleted: { [weak self] in
                    self?.isLoading = false
                }
            ).disposed(by: disposeBag)
    }
    
    public func insertGameLocal(gameDetail: GameDetail) {
        appRepository.insertGameLocal(gameDetail: gameDetail).subscribe(
            onNext: { [weak self] game in
//                self?.gameLocal = game
                self?.isFavorite = !self!.isFavorite
                self?.isLoading = false
            },
            onError: { [weak self] error in
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
            },
            onCompleted: { [weak self] in
                self?.isLoading = false
            }
        ).disposed(by: disposeBag)
    }

    public func deleteGameLocal(game : GameDetail) {
        appRepository.deleteGameLocal(gameDetail: game).subscribe(
            onNext: { [weak self] game in
                self?.isLoading = false
                self?.isFavorite = !self!.isFavorite
            },
            onError: { [weak self] error in
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
            },
            onCompleted: { [weak self] in
                self?.isLoading = false
            }
        ).disposed(by: disposeBag)
    }
    
    public func checkingFavorite(for id: Int) {
        appRepository.checkingFavorite(id: id)
            .subscribe(
                onNext: { [weak self] game in
                    self?.isFavorite = game
                },
                onError: { [weak self] error in
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                },
                onCompleted: { [weak self] in
                    self?.isLoading = false
                }
            ).disposed(by: disposeBag)
    }
}
