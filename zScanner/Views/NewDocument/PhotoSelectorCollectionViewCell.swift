//
//  PhotoSelectorCollectionViewCell.swift
//  zScanner
//
//  Created by Jakub Skořepa on 14/08/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import UIKit

protocol PhotoSelectorCellDelegate: class {
    func delete(image: PageDomainModel)
}

// MARK: -
class PhotoSelectorCollectionViewCell: UICollectionViewCell {
    
    // MARK: Instance part
    private var picture: PageDomainModel? {
        didSet {
            imageView.image = picture?.image
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
        
        picture = nil
    }
    
    // MARK: Interface
    func setup(with picture: PageDomainModel, delegate: PhotoSelectorCellDelegate) {
        self.picture = picture
        self.delegate = delegate
    }
    
    // MARK: Helpers
    private weak var delegate: PhotoSelectorCellDelegate?
    
    @objc private func deleteImage() {
        guard let picture = picture else { return }
        delegate?.delete(image: picture)
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textView.delegate = self
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.width.equalToSuperview()
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
    
    private var textView : UITextView = {
        let text = UITextView()
        text.text = "newDocumentPhotos.description.placeholder".localized
        text.textColor = UIColor.lightGray
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

extension PhotoSelectorCollectionViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
       }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "newDocumentPhotos.description.placeholder".localized
            textView.textColor = UIColor.lightGray
        }
    }
}
