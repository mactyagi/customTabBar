
// CustomTabBarView.swift

import UIKit

protocol CustomTabBarDelegate: AnyObject {
    func didSelectTab(at index: Int)
}

class CustomTabBarView: UIView {

    weak var delegate: CustomTabBarDelegate?

    private let tabBarItems: [CustomTabBarItem]
    private var stackView: UIStackView!
    private var shapeLayer = CAShapeLayer()

    init(tabBarItems: [CustomTabBarItem]) {
        
        self.tabBarItems = tabBarItems
        super.init(frame: .zero)
        setupTabBar()
        setupShapeLayer()
        
    }
    
    func setupShapeLayer() {
        
        print(self.frame)
        print(self.bounds)
        let path = createNewPath()
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = path.cgPath
        layer.insertSublayer(shapeLayer, at: 0)
        
    }
    
    func createNewPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -self.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.height / 2, y: 0))
        print(self.frame)
        
        
        path.addArc(withCenter: CGPoint(x: self.bounds.height / 2, y: self.bounds.height / 2), radius: self.bounds.height / 2 + 10, startAngle: Double.pi * 27 / 18, endAngle: Double.pi / 2, clockwise: false)
        
        path.addLine(to: CGPoint(x: -self.bounds.width, y: self.bounds.height))
        path.close()
        
        path.move(to: CGPoint(x: self.bounds.height, y: self.bounds.height / 2))
        
        path.addArc(withCenter: CGPoint(x: self.bounds.height / 2, y: self.bounds.height / 2), radius: self.bounds.height / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        path.move(to: CGPoint(x: self.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.height / 2, y: 0))
        
        path.addArc(withCenter: CGPoint(x: self.bounds.height / 2, y: self.bounds.height / 2), radius: self.bounds.height / 2 + 10, startAngle: Double.pi * 27 / 18, endAngle: Double.pi / 2, clockwise: true)
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        path.close()
        
        return path
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTabBar() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabBarItemTapped))
        addGestureRecognizer(tapGesture)
        
        stackView = UIStackView(arrangedSubviews: tabBarItems)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Add any additional customization or styling here
    }

    @objc private func tabBarItemTapped(_ sender: UITapGestureRecognizer) {
        if let tappedIndex = stackView.subviews.firstIndex(of: sender.view as! CustomTabBarItem) {
            delegate?.didSelectTab(at: tappedIndex)
        }
    }
}


// CustomTabBarItem.swift

import UIKit

class CustomTabBarItem: UIView {

//    private let titleLabel: UILabel
    private let iconImageView: UIImageView

    init(title: String, icon: UIImage?) {
//        titleLabel = UILabel()
        iconImageView = UIImageView()

        super.init(frame: .zero)

//        titleLabel.text = title
        iconImageView.image = icon

        setupTabBarItem()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTabBarItem() {
        // Add subviews, set up constraints, and customize styling here
        backgroundColor = .gray
        // Add the icon image view
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor), // Adjust the top space as needed
            iconImageView.widthAnchor.constraint(equalToConstant: 30), // Adjust the width as needed
            iconImageView.heightAnchor.constraint(equalToConstant: 30) // Adjust the height as needed
        ])

        // Add the title label
//        addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4), // Adjust the spacing between icon and title
//        ])

        // Example: Add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabBarItemTapped))
        addGestureRecognizer(tapGesture)
    }

    @objc private func tabBarItemTapped() {
        // Handle tab bar item tap actions here
//        print("Tab Bar Item Tapped: \(titleLabel.text ?? "")")
    }
}


// CustomTabBarController.swift

import UIKit

class CustomTabBarController: UITabBarController {

    private var customTabBar: CustomTabBarView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create your tab bar items
        let item1 = CustomTabBarItem(title: "", icon: UIImage(systemName: "house.fill"))
        let item2 = CustomTabBarItem(title: "Second", icon: UIImage(named: "house.fill"))

        // Create the custom tab bar with the items
        customTabBar = CustomTabBarView(tabBarItems: [item1, item2])
        customTabBar.delegate = self
        customTabBar.backgroundColor = .black

        // Add the custom tab bar to the tab bar controller
        tabBar.addSubview(customTabBar)
        

        // Set up constraints as needed
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: 10),
            customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: -10),
            customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor, constant:  -20),
            customTabBar.heightAnchor.constraint(equalToConstant: 60) // Adjust the height as needed
        ])
        
        customTabBar.setupShapeLayer()

        // Set up your view controllers
        let firstViewController = UIViewController()
        firstViewController.view.backgroundColor = .red
//        firstViewController.title = "First"

        let secondViewController = UIViewController()
        secondViewController.view.backgroundColor = .blue
//        secondViewController.title = "Second"

        // Set the view controllers for the tab bar
        viewControllers = [firstViewController, secondViewController]
    }
}

extension CustomTabBarController: CustomTabBarDelegate {
    func didSelectTab(at index: Int) {
        // Handle tab selection here, e.g., switch view controllers
        selectedIndex = index
    }
}
