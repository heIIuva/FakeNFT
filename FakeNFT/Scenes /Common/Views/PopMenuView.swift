//
//  PopMenuView.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 31.03.2025.
//

import UIKit

final class PopupMenuView: UIView {

    struct MenuItem {
        let title: String
        let action: () -> Void
    }

    struct Style {
        let backgroundColor: UIColor
        let cornerRadius: CGFloat
        let font: UIFont
        let textColor: UIColor
        let buttonBackgroundColor: UIColor
    }

    private var items: [MenuItem] = []
    private let style: Style

    private let backgroundDismissView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let menuContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(items: [MenuItem], style: Style) {
        self.items = items
        self.style = style
        super.init(frame: .zero)
        setupView()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear

        addSubview(backgroundDismissView)
        addSubview(menuContainer)

        menuContainer.backgroundColor = style.backgroundColor
        menuContainer.layer.cornerRadius = style.cornerRadius
        menuContainer.clipsToBounds = true

        menuContainer.addSubview(stackView)

        NSLayoutConstraint.activate([
            backgroundDismissView.topAnchor.constraint(equalTo: topAnchor),
            backgroundDismissView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundDismissView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundDismissView.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: menuContainer.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: menuContainer.bottomAnchor),
        ])

        for (index, item) in items.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(item.title, for: .normal)
            button.setTitleColor(style.textColor, for: .normal)
            button.titleLabel?.font = style.font
            button.backgroundColor = style.buttonBackgroundColor
            button.contentEdgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
            button.tag = index
            button.addTarget(self, action: #selector(menuItemTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundDismissView.addGestureRecognizer(tap)
    }

    @objc private func backgroundTapped() {
        removeFromSuperview()
    }

    @objc private func menuItemTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < items.count else { return }
        items[index].action()
        removeFromSuperview()
    }

    static func show(
        under view: UIView,
        in container: UIView,
        items: [MenuItem],
        width: CGFloat = 250,
        style: Style
    ) {
        let popup = PopupMenuView(items: items, style: style)
        popup.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(popup)

        NSLayoutConstraint.activate([
            popup.topAnchor.constraint(equalTo: container.topAnchor),
            popup.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            popup.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            popup.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        popup.menuContainer.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(popup.menuContainer)

        NSLayoutConstraint.activate([
            popup.menuContainer.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 4),
            popup.menuContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popup.menuContainer.widthAnchor.constraint(equalToConstant: width)
        ])
    }
}
