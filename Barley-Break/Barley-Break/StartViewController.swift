//
//  StartViewController.swift
//  Barley-Break
//
//  Created by Developer on 18.08.2022.
//

import UIKit

class StartViewController: UIViewController {
    
    private let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    private let sectionInserts: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private var playingField = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", ""]
    var numberOfMoves: Int = 0 {
        didSet {
            moveCounterLabel.text = String(numberOfMoves)
        }
    }
    
    let itemsPerRow: Int = 4
    var indexEmptyCell: Int = 16
    lazy var itemPerColumn: Int = playingField.count / itemsPerRow

    private var newGameButton: UIButton = UIButton(type: .system)
    private var moveCounterLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StartCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(StartCollectionViewCell.self))
        setupUIElements()
    }
    
    private func setupUIElements() {
        view.addSubview(collectionView)
        view.addSubview(newGameButton)
        collectionView.addSubview(moveCounterLabel)
        view.backgroundColor = .darkGray
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .darkGray
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 450).isActive = true
        
        moveCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        moveCounterLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        moveCounterLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20).isActive = true
        moveCounterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        newGameButton.setTitle("New game", for: .normal)
        newGameButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        newGameButton.setTitleColor(.white, for: .normal)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.addTarget(self, action: #selector(didTapNewGameButton), for: .touchUpInside)
        newGameButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20).isActive = true
        newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func didTapNewGameButton() {
        playingField.shuffle()
        numberOfMoves = 0
        collectionView.reloadData()
    }
    
    private func moveLeftOrUp(shiftIndex: Int) {
        let removedIndex = playingField.remove(at: indexEmptyCell - shiftIndex)
        playingField.insert(removedIndex, at: indexEmptyCell)
        let removedElement = playingField.remove(at: indexEmptyCell - 1)
        playingField.insert(removedElement, at: indexEmptyCell - shiftIndex)
        indexEmptyCell = indexEmptyCell - shiftIndex
    }
    
    private func moveRightOrDown(shiftIndex: Int) {
        let removedIndex = playingField.remove(at: indexEmptyCell + shiftIndex)
        playingField.insert(removedIndex, at: indexEmptyCell)
        let removedElement = playingField.remove(at: indexEmptyCell + 1)
        playingField.insert(removedElement, at: indexEmptyCell + shiftIndex)
        indexEmptyCell = indexEmptyCell + shiftIndex
    }
}

extension StartViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return StartCollectionViewCell.size(for: collectionView.frame.size, itemsPerRow: CGFloat(itemsPerRow))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playingField.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(StartCollectionViewCell.self), for: indexPath) as! StartCollectionViewCell
        cell.backgroundColor = .gray

        if playingField[indexPath.row].isEmpty {
            indexEmptyCell = indexPath.row
        }
        
        cell.numberLabel.text = playingField[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row / itemsPerRow == (indexEmptyCell / itemsPerRow) {
            
            let stepsCount: Int = abs((indexEmptyCell % 4) - (indexPath.row % 4))
            for _ in 0..<stepsCount {
                if indexPath.row < indexEmptyCell {
                    moveLeftOrUp(shiftIndex: 1)
                } else {
                    moveRightOrDown(shiftIndex: 1)
                }
                numberOfMoves += 1
            }
            
        } else {
            let stepsCount: Int = abs((indexEmptyCell / 4) - (indexPath.row / 4))
            for _ in 0..<stepsCount {
                if indexPath.row < indexEmptyCell {
                    moveLeftOrUp(shiftIndex: itemsPerRow)
                } else {
                    moveRightOrDown(shiftIndex: itemsPerRow)
                }
                numberOfMoves += 1
            }
        }
        let sortedPlayingField = playingField.sorted(
            by: { value1, value2 in
                let value1Int: Int = Int(value1) ?? playingField.count
                let value2Int: Int = Int(value2) ?? playingField.count
                
                return value1Int < value2Int
            }
        )
        
        if playingField == sortedPlayingField {
            presentErrorAlert()
        }
        
        collectionView.reloadData()
    }
}

extension UIViewController {
    func presentErrorAlert() {
        let alert = UIAlertController(title: "VICTORY!!!", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
