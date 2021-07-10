import UIKit

protocol HeaderViewDelegate: AnyObject {
    func headerView(_ headerView: HeaderView, didPressCloseButton closeButton: UIButton)
}

open class HeaderView: UIView {
    open fileprivate(set) lazy var closeButton: UIButton = { [unowned self] in
        let title = NSAttributedString(
            string: LightboxConfig.CloseButton.text,
            attributes: LightboxConfig.CloseButton.textAttributes)
        
        let button = UIButton(type: .system)
        
        button.setAttributedTitle(title, for: UIControl.State())
        
        if let size = LightboxConfig.CloseButton.size {
            button.frame.size = size
        } else {
            button.sizeToFit()
        }
        
        button.addTarget(self, action: #selector(closeButtonDidPress(_:)),
                         for: .touchUpInside)
        
        if let image = LightboxConfig.CloseButton.image {
            button.setBackgroundImage(image, for: UIControl.State())
        }
        
        button.isHidden = !LightboxConfig.CloseButton.enabled
        
        return button
    }()
    
    var actionViews: [UIView] = []
    
    public func addActionView(_ actionView: UIView) {
        actionViews.append(actionView)
        addSubview(actionView)
        actionView.sizeToFit()
        configureLayout()
    }
    
    weak var delegate: HeaderViewDelegate?
    
    // MARK: - Initializers
    
    public init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.clear
        
        addSubview(closeButton)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func closeButtonDidPress(_ button: UIButton) {
        delegate?.headerView(self, didPressCloseButton: button)
    }
}

// MARK: - LayoutConfigurable

extension HeaderView: LayoutConfigurable {
    
    @objc public func configureLayout() {
        let topPadding: CGFloat
        
        if #available(iOS 11, *) {
            topPadding = safeAreaInsets.top
        } else {
            topPadding = 0
        }
        
        closeButton.frame.origin = CGPoint(
            x: bounds.width - closeButton.frame.width - 17,
            y: topPadding
        )
        
        var x: CGFloat = 17
        for view in actionViews {
            view.frame.origin = CGPoint(
                x: x,
                y: topPadding
            )
            
            x += view.frame.size.width + 8.0
        }
    }
}
