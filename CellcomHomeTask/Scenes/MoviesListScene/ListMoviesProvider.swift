//
//  ListMoviesProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 20.11.2023.
//

protocol ListMoviesProvider: MyFavoriteMoviesProvider, PopularMoviesProvider, CurrentlyBroadcastMoviesProvider {}

extension NetworkWorker: ListMoviesProvider {}

extension AccountDetailsProviderNetworkDecorator: ListMoviesProvider where T: ListMoviesProvider { }

extension AuthenticationNetworkDecorator: ListMoviesProvider where T: ListMoviesProvider { }
