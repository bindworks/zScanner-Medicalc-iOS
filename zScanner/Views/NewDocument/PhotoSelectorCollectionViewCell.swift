//
//  PhotoSelectorCollectionViewCell.swift
//  zScanner
//
//  Created by Jakub Skořepa on 14/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol PhotoSelectorCellDelegate: class {
    func delete(page: Page)
}

// MARK: -
class PhotoSelectorCollectionViewCell: UICollectionViewCell {
    
    // MARK: Instance part
    private var page: Page? {
        didSet {
            imageView.image = page?.image
            textField.text = page?.description.value
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        page = nil
        disposeBag = DisposeBag()
    }
    
    // MARK: Interface
    func setup(with page: Page, delegate: PhotoSelectorCellDelegate) {
        self.page = page
        self.delegate = delegate
        
        textField.rx.text
            .orEmpty
            .bind(to: page.description)
            .disposed(by: disposeBag)
    }
    
    // MARK: Helpers
    private var disposeBag = DisposeBag()
    
    private weak var delegate: PhotoSelectorCellDelegate?
    
    @objc private func deleteImage() {
        guard let page = page else { return }
        delegate?.delete(page: page)
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.height.equalTo(36)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.top.right.equalToSuperview().inset(4)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
    }
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var textField : UITextField = {
        let text = UITextField()
        text.font = .body
        text.placeholder = "newDocumentPhotos.description.placeholder".localized
        text.backgroundColor = .white
        text.delegate = self
        return text
    }()

    private var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "delete").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.dropShadow()
        return button
    }()
}

extension PhotoSelectorCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setBottomBorder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setBottomBorder(show: false)
    }
}
