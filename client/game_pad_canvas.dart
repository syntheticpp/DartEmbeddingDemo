/**
 * Dart Embedding Example
 *
 * ---------------------------------------------------------------------
 *
 * Copyright (c) 2012 Don Olmstead
 * 
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 *   1. The origin of this software must not be misrepresented; you must not
 *   claim that you wrote the original software. If you use this software
 *   in a product, an acknowledgment in the product documentation would be
 *   appreciated but is not required.
 *
 *   2. Altered source versions must be plainly marked as such, and must not be
 *   misrepresented as being the original software.
 * 
 *   3. This notice may not be removed or altered from any source
 *   distribution.
 */

class Point2D implements Point
{
  /// The x position
  final num x;
  /// The y position
  final num y;
  
  const Point2D(num this.x, num this.y);
}

class GamePadCanvas
{
  /// Position of the XBox 360 controller
  static final Point2D _controllerPosition = const Point2D(50, 10);
  /// Position of the XBox button
  static final Point2D _xBoxButtonPosition = const Point2D(351, 107);
  /// Position of the X button
  static final Point2D _xButtonPosition = const Point2D(542, 123);
  /// Position of the Y button
  static final Point2D _yButtonPosition = const Point2D(604, 60);
  /// Position of the A button
  static final Point2D _aButtonPosition = const Point2D(604, 186);
  /// Position of the B button
  static final Point2D _bButtonPosition = const Point2D(666, 122);
  /// Position of the start button
  static final Point2D _startButtonPosition = const Point2D(318, 154);
  /// Position of the back button
  static final Point2D _backButtonPosition = const Point2D(487, 154);
  /// Position of the left shoulder button
  static final Point2D _leftShoulderButtonPosition = const Point2D(166, 22);
  /// Position of the right shoulder button
  static final Point2D _rightShoulderButtonPosition = const Point2D(641, 22);
  /// Position of the d-pad up button
  static final Point2D _dPadUpButtonPosition = const Point2D(278, 249);
  /// Position of the d-pad down button
  static final Point2D _dPadDownButtonPosition = const Point2D(278, 338);
  /// Position of the d-pad left button
  static final Point2D _dPadLeftButtonPosition = const Point2D(232, 292);
  /// Position of the d-pad right button
  static final Point2D _dPadRightButtonPosition = const Point2D(323, 292);
  /// Position of the left thumbstick
  static final Point2D _leftThumbstickCenter = const Point2D(166, 151.5);
  /// Position of the right thumbstick
  static final Point2D _rightThumbstickCenter = const Point2D(514, 294.5);
  /// The radius of the thumbstick
  static final double _thumbstickRadius = 25.0;
  
  /// Position of the left trigger meter
  static final Point2D _leftTriggerMeterPosition = const Point2D(22, 110);
  /// Position of the right trigger meter
  static final Point2D _rightTriggerMeterPosition = const Point2D(849, 110);
  /// The border color for the meter
  static final String _meterStrokeStyle = 'rgba(255, 255, 255, 1.0)';
  /// The meter color
  static final String _meterFillStyle = 'rgba(191, 191, 191, 1.0)';
  /// The border thickness of the meter
  static final double _meterBorderThickness = 2.0;
  /// The width of the meter
  static final double _meterWidth = 29.0;
  /// The height of the meter
  static final double _meterHeight = 204.0;
  
  /// The color to use when drawing circles
  static final String _circleFillStyle = 'rgba(251, 239, 42, 0.75)';
  
  /// The canvas element
  CanvasElement _canvas;
  /// The rendering context
  CanvasRenderingContext2D _context;
  
  /// Image of the XBox 360 controller
  ImageElement _controllerImage;
  /// Image of the left thumbstick
  ImageElement _leftThumbstickImage;
  /// Image of the right thumbstick
  ImageElement _rightThumbstickImage;
  /// Images for the player's connection
  List<ImageElement> _playerImages;
  /// Image of the X button
  ImageElement _xButtonImage;
  /// Image of the Y button
  ImageElement _yButtonImage;
  /// Image of the A button
  ImageElement _aButtonImage;
  /// Image of the B button
  ImageElement _bButtonImage;
  
  int _playerIndex;
  GamePadState _gamePadState;
  
  GamePadCanvas(String id)
  {
    _playerIndex = 0;
    _gamePadState = new GamePadState();
    
    _canvas = document.query(id) as CanvasElement;
    assert(_canvas != null);
    
    _context = _canvas.getContext('2d');
    assert(_context != null);
    
    // Load the images
    _controllerImage = _loadImage('images/controller.png');
    _leftThumbstickImage = _loadImage('images/left_thumb.png');
    _rightThumbstickImage = _loadImage('images/right_thumb.png');
    
    _xButtonImage = _loadImage('images/x.png');
    _yButtonImage = _loadImage('images/y.png');
    _aButtonImage = _loadImage('images/a.png');
    _bButtonImage = _loadImage('images/b.png');
    
    _playerImages = new List<ImageElement>();
    _playerImages.add(_loadImage('images/player_1.png'));
    _playerImages.add(_loadImage('images/player_2.png'));
    _playerImages.add(_loadImage('images/player_3.png'));
    _playerImages.add(_loadImage('images/player_4.png'));
  }
  
  void draw()
  {
    // Get the game pad
    
    // Draw the game pad
    _context.drawImage(_controllerImage, _controllerPosition.x, _controllerPosition.y);
    
    // See if the game pad is connected
    if (_gamePadState.isConnected)
    {
      // Draw the connected image
      _drawImage(_playerImages[_playerIndex], _xBoxButtonPosition);

      // Draw the button images
      if (_gamePadState.x)
        _drawImage(_xButtonImage, _xButtonPosition);
      if (_gamePadState.y)
        _drawImage(_yButtonImage, _yButtonPosition);
      if (_gamePadState.a)
        _drawImage(_aButtonImage, _aButtonPosition);
      if (_gamePadState.b)
        _drawImage(_bButtonImage, _bButtonPosition);
    
      // Draw the start/back circles
      if (_gamePadState.start)
        _drawCircle(12, _startButtonPosition);
      if (_gamePadState.back)
        _drawCircle(12, _backButtonPosition);
      
      // Draw the shoulder circles
      if (_gamePadState.leftShoulder)
        _drawCircle(12, _leftShoulderButtonPosition);
      if (_gamePadState.rightShoulder)
        _drawCircle(12, _rightShoulderButtonPosition);
      
      // Draw the D-Pad circles
      if (_gamePadState.up)
        _drawCircle(12, _dPadUpButtonPosition);
      if (_gamePadState.down)
        _drawCircle(12, _dPadDownButtonPosition);
      if (_gamePadState.left)
        _drawCircle(12, _dPadLeftButtonPosition);
      if (_gamePadState.right)
        _drawCircle(12, _dPadRightButtonPosition);
    }
    
    // Draw meters showing the triggers
    _drawTriggerMeter(_leftTriggerMeterPosition, 0.5);
    _drawTriggerMeter(_rightTriggerMeterPosition, 0.75);
    
    // Draw thumbsticks
    _drawThumbstick(_leftThumbstickImage, _gamePadState.leftThumbstick, _leftThumbstickCenter, _gamePadState.leftStick);
    _drawThumbstick(_rightThumbstickImage, _gamePadState.rightThumbstick, _rightThumbstickCenter, _gamePadState.rightStick);
  }
  
  void _drawImage(ImageElement image, Point2D position)
  {
    num x = _controllerPosition.x + position.x;
    num y = _controllerPosition.y + position.y;
    
    _context.drawImage(image, x, y);
  }
  
  void _drawCircle(int radius, Point2D position)
  {
    _drawCircleAt(radius, position.x, position.y);
  }
    
  void _drawCircleAt(int radius, num x, num y)
  {
    x += _controllerPosition.x;
    y += _controllerPosition.y;
    
    _context.strokeStyle = _circleFillStyle;
    _context.fillStyle = _circleFillStyle;
    _context.beginPath();
    _context.arc(x, y, radius, 0, Math.PI*2, true);
    _context.closePath();
    _context.fill();
  }
  
  void _drawThumbstick(ImageElement image, Point2D value, Point2D center, bool pressed)
  {
    num centerX = (value.x * _thumbstickRadius) + center.x + _controllerPosition.x; 
    num centerY = (value.y * _thumbstickRadius) + center.y + _controllerPosition.y;
    
    num imageX = centerX - (image.width * 0.5);
    num imageY = centerY - (image.height * 0.5);
    
    _context.drawImage(image, imageX, imageY);
    
    if (pressed)
      _drawCircleAt(12, centerX, centerY);
  }
  
  void _drawTriggerMeter(Point2D position, num fill)
  {
    // Draw the outline
    _context.strokeStyle = _meterStrokeStyle;
    _context.lineWidth = _meterBorderThickness;
    
    _context.strokeRect(position.x, position.y, _meterWidth, _meterHeight);
    
    // Draw the filled meter
    if (fill > 0.0)
    {
      num totalBorderThickness = 2.0 * _meterBorderThickness;
      num width = _meterWidth - totalBorderThickness;
      num meterHeight = _meterHeight - totalBorderThickness;
      num height = fill * meterHeight;
      
      num x = position.x + _meterBorderThickness;
      num y = position.y + _meterBorderThickness + (meterHeight - height);
      
      _context.strokeStyle = _meterFillStyle;
      _context.fillStyle = _meterFillStyle;
      _context.fillRect(x, y, width, height);
    }
  }
  
  static ImageElement _loadImage(String source)
  {
    ImageElement image = new ImageElement();
    image.src = source;
    
    return image;
  }
}