import UIKit
import Kingfisher

protocol GifListCellDelegate: AnyObject {
    func reloadCellHeight(numberRow: Int)
}

final class GifListCell: UITableViewCell {
    
    static let reuseIdentifier = "gifCell"
    
    lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(cellImageView)
        activateConstraints()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configCell(imageURL: String, numberRow: Int, tableViewHeight: CGFloat) {
        let cellHeight = tableViewHeight / 3.0
        cellImageView.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
        downloadImage(at: imageURL, numberRow: numberRow)
    }
    
    private func downloadImage(at url: String, numberRow: Int) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.main.async {
            self.cellImageView.kf.setImage(with: url,
                                           placeholder: UIImage(named: "heart"),
                                           options: nil) { [weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let value):
                        self.cellImageView.image = value.image
                    case .failure(_):
                        self.cellImageView.image = UIImage(named: "heart")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
        cellImageView.image = nil
    }
    
}
