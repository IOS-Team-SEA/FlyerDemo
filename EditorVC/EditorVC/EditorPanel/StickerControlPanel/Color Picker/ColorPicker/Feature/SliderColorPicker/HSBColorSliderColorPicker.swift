import UIKit

public class HSBColorSliderColorPicker: UIControl, AnyColorPicker {
    public var title: String = "HSB"
    
    public let id: String = #function
    
    let hueSlider = ColorSliderWithInputView()
    let saturationSlider = ColorSliderWithInputView()
    let brightnessSlider = ColorSliderWithInputView()
    
    private var _color: HSVA = .noop
    
    public var color: HSVA {
        get { _color }
        set {
            _color = newValue
            hueSlider.color = newValue
            saturationSlider.color = newValue
            brightnessSlider.color = newValue
        }
    }
    
    public var continuously: Bool {
        [
            hueSlider.slider.panGestureRecognizer.state,
            saturationSlider.slider.panGestureRecognizer.state,
            brightnessSlider.slider.panGestureRecognizer.state
        ].contains(.changed)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        hueSlider.slider.configuration = .hue
        hueSlider.textField.configuration = .radius
        hueSlider.titleLabel.text = "hue"
        
        saturationSlider.slider.configuration = .saturation
        saturationSlider.textField.configuration = .percent
        saturationSlider.titleLabel.text = "saturation"
        
        brightnessSlider.slider.configuration = .brightness
        brightnessSlider.textField.configuration = .percent
        brightnessSlider.titleLabel.text = "brightness"
        
        let vStack = UIStackView(arrangedSubviews: [hueSlider, saturationSlider, brightnessSlider])
        vStack.axis = .vertical
        vStack.spacing = 16
        addSubview(vStack)
        
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let valueSyncAction = UIAction { [weak self] action in
            let slider = (action.sender as! ColorSliderWithInputView).slider
            self?.color = slider.color
            self?.sendActions(for: [.valueChanged, .primaryActionTriggered])
        }
        hueSlider.addAction(valueSyncAction, for: .primaryActionTriggered)
        saturationSlider.addAction(valueSyncAction, for: .primaryActionTriggered)
        brightnessSlider.addAction(valueSyncAction, for: .primaryActionTriggered)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

