//
//  BaseViewModel.swift
//  Test_2
//
//  Created by Abdul Sami on 29/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import Foundation

public class BaseViewModel {
    
    public weak var delegate : BaseViewModelDelegate?
    private var ready:Bool = false
    private var loading:Bool = false
    
    public func load() {
        self.loading = true
    }
    
    public func isReady(_ shouldNotifyDelegate: Bool = true)->Bool {
        if ready && shouldNotifyDelegate {
            self.makeReady()
        }
        return ready
    }
    
    public func isLoading() -> Bool {
        return loading
    }
    
    public func makeReady() {
        self.ready = true
        self.loading = false
        self.delegate?.onViewModelReady(self)
    }
    
    public func throwError(with error: Error) {
        self.loading = false
        self.delegate?.onViewModelError(self, error: error)
    }
}

public protocol BaseViewModelDelegate : class {
    func onViewModelReady(_ viewModel: BaseViewModel)
    func onViewModelError(_ viewModel: BaseViewModel, error: Error)
}

