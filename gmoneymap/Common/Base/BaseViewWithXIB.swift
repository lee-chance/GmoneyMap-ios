//
//  BaseViewWithXIB.swift
//  Base
//
//  Created by Changsu Lee on 2021/06/02.
//

class BaseViewWithXIB: UIView {
    
    var view:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //autoresizing 은 setupView() 안에서는 효과 없음
    func setupView() {
        self.view = viewFromNibForClass()
        self.view?.frame = bounds
        self.view?.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(self.view!)
    }
    
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
}
