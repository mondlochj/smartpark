import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No cameras found');
    }
  } catch (e) {
    print('Error initializing cameras: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPark',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(Duration(seconds: 3), () {
      if (_tapCount < 5) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _tapCount++;
        if (_tapCount == 5) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfigurationScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.yellow,
        body: Center(
          child: SizedBox.expand(
            child: Image.asset(
              'assets/splash_image.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _apiKey;
  String? _serverIp;

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKey = prefs.getString('apiKey') ?? 'X9gP4L7sH2J8kQ0wB5mN3dV6tYzR1aW';
      _serverIp = prefs.getString('serverIp') ?? 'aroaero.com/license_plates_php/api.php';
    });
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and password cannot be empty')),
      );
      return;
    }

    if (_apiKey == null || _serverIp == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('API key or Server IP not configured')),
      );
      return;
    }

    final url = Uri.parse('https://$_serverIp?endpoint=login&username=$username&password=$password');

    try {
      final client = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final ioClient = IOClient(client);
      final response = await ioClient.get(url, headers: {'API-Key': _apiKey!});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['message'] == 'Login successful') {
          final token = data['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('username', username);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CameraScreen(username: username)),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid username or password')),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login, please try again')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.yellow,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Image.asset(
                'assets/icon/app_icon.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                'smartpark',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final String username;
  CameraScreen({required this.username});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  late TextRecognizer _textRecognizer;
  bool _isProcessing = false;
  String? _recognizedPlate;
  String? _firstName;
  String? _lastName;
  String? _phone;
  List<String>? _groups;
  String? _lastRecognizedPlate;
  DateTime? _lastRecognizedTime;
  Map<String, dynamic>? _localDatabase;
  Timer? _timeoutTimer;

  // Configuration parameters
  late String serverIp;
  late String apiKey;
  late RegExp recognitionRegex;
  late int recognitionTimeout;
  late int plateUpdateInterval;

  // Camera control variables
  double _zoomLevel = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  bool _isFrontCamera = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeConfiguration();
  }

  Future<void> _initializeConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      serverIp = prefs.getString('serverIp') ?? 'aroaero.com/license_plates_php/api.php';
      apiKey = prefs.getString('apiKey') ?? 'X9gP4L7sH2J8kQ0wB5mN3dV6tYzR1aW';
	  recognitionRegex = RegExp(prefs.getString('recognitionRegex') ?? r'^(?:[POCM] ?)?\d{3}[BCDFGHJKLMNPQRSTVWXYZ]{3}$');
      recognitionTimeout = int.tryParse(prefs.getString('recognitionTimeout') ?? '30') ?? 30;
      plateUpdateInterval = int.tryParse(prefs.getString('plateUpdateInterval') ?? '10') ?? 10;
    });

    await _initializeCamera();
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    _loadLocalDatabase();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      try {
        _cameraController = CameraController(
          cameras[_isFrontCamera ? 1 : 0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        _minZoom = await _cameraController!.getMinZoomLevel();
        _maxZoom = await _cameraController!.getMaxZoomLevel();
        setState(() {});
        _startImageStream();
      } catch (e) {
        print('Error initializing camera: $e');
        _showSnackBar('Failed to initialize the camera');
      }
    } else {
      _showSnackBar('Camera permission denied');
    }
  }

  Future<void> _loadLocalDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('localDatabase');
    if (data != null) {
      setState(() {
        _localDatabase = json.decode(data);
      });
      print('Local database loaded');
    } else {
      print('No local database found');
    }
  }

  void _startImageStream() {
    _cameraController!.startImageStream((image) async {
      if (_isProcessing) return;
      _isProcessing = true;

      final allBytes = image.planes.fold<List<int>>(
        <int>[],
        (List<int> previousValue, Plane plane) => previousValue..addAll(plane.bytes),
      );
      final bytes = Uint8List.fromList(allBytes);

      final InputImageData inputImageData = InputImageData(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        imageRotation: _rotationIntToImageRotation(_cameraController!.description.sensorOrientation),
        inputImageFormat: InputImageFormat.nv21,
        planeData: image.planes.map(
          (Plane plane) {
            return InputImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width,
            );
          },
        ).toList(),
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      _processRecognizedText(recognizedText);
      _isProcessing = false;
    });
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

	void _processRecognizedText(RecognizedText recognizedText) {
	  for (final block in recognizedText.blocks) {
		for (final line in block.lines) {
		  String text = line.text.replaceAll(' ', '').toUpperCase();		  
		  if (RegExp(r'^\d{3}[A-Z]{3}$').hasMatch(text)) {
			text = 'P' + text;
		  }	  
		  if (recognitionRegex.hasMatch(text)) {
			if (_lastRecognizedPlate == null || !_isSimilarPlate(text, _lastRecognizedPlate!)) {
			  _lookupLicensePlate(text);
			  _lastRecognizedPlate = text;
			  _lastRecognizedTime = DateTime.now();
			}
			_resetTimeoutTimer();
			return;
		  }
		}
	  }
	}





  Future<void> _lookupLicensePlate(String licensePlate) async {
    setState(() {
      _recognizedPlate = licensePlate;
      _firstName = null;
      _lastName = null;
      _phone = null;
      _groups = null;
    });

    if (_localDatabase != null && _localDatabase!.containsKey(licensePlate)) {
      print('Found in local database');
      final data = _localDatabase![licensePlate];
      setState(() {
        _firstName = data['first_name'];
        _lastName = data['last_name'];
        _phone = data['phone'];
        _groups = List<String>.from(data['groups']);
      });
    } else {
      print('Not found in local database, trying online lookup');
      try {
        final client = _createHttpClient();
        final url = Uri.parse('https://$serverIp?endpoint=lookup&license_plate=$licensePlate');
        print('Sending request to: $url'); // Debugging line
        final response = await client.get(url, headers: {'API-Key': apiKey});
        print('API response status: ${response.statusCode}, Body: ${response.body}'); // Debugging line

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _firstName = data['first_name'];
            _lastName = data['last_name'];
            _phone = data['phone'];
            _groups = List<String>.from(data['groups']);
          });
        } else {
          print('Failed to load data from server');
        }
      } catch (e) {
        print('Error: $e');
        _showSnackBar('Network error: $e');
      }
    }
  }

  bool _isSimilarPlate(String newPlate, String oldPlate) {
    if (oldPlate == null) return false;

    int diffCount = 0;
    for (int i = 0; i < newPlate.length; i++) {
      if (newPlate[i] != oldPlate[i]) {
        diffCount++;
        if (diffCount > 2) {
          return false;
        }
      }
    }

    // Additional check: ensure a minimum time difference between similar plates
    final currentTime = DateTime.now();
    if (_lastRecognizedTime != null && currentTime.difference(_lastRecognizedTime!).inSeconds < recognitionTimeout) {
      return true;
    }
    return false;
  }

  void _resetTimeoutTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(Duration(seconds: recognitionTimeout), () {
      setState(() {
        _recognizedPlate = null;
        _firstName = null;
        _lastName = null;
        _phone = null;
        _groups = null;
        _lastRecognizedPlate = null;
        _lastRecognizedTime = null;
      });
    });
  }

  IOClient _createHttpClient() {
    final ioc = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(ioc);
  }

  Future<void> _downloadDatabase() async {
    try {
      final client = _createHttpClient();
      final url = Uri.parse('https://$serverIp?endpoint=all_data');
      final response = await client.get(url, headers: {'API-Key': apiKey});

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('localDatabase', json.encode(data));
          setState(() {
            _localDatabase = data;
          });
          print('Database downloaded and saved locally');
          _showSnackBar('Database downloaded');
        } catch (e) {
          print('Error parsing database: $e');
          _showSnackBar('Failed to parse database');
        }
      } else {
        print('Failed to download database: ${response.statusCode}');
        _showSnackBar('Failed to download database: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      _showSnackBar('Network error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _toggleFlash() async {
    if (_cameraController != null) {
      _isFlashOn = !_isFlashOn;
      await _cameraController!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
      setState(() {});
    }
  }

  void _toggleCamera() async {
    _isFrontCamera = !_isFrontCamera;
    await _cameraController?.dispose();
    await _initializeCamera();
  }

  void _handleScaleStart(ScaleStartDetails details) {}

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _zoomLevel = (_zoomLevel * details.scale).clamp(_minZoom, _maxZoom);
      _cameraController?.setZoomLevel(_zoomLevel);
    });
  }

  void _savePlate() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'plate_${DateTime.now().millisecondsSinceEpoch}';
    final data = json.encode({'plate': _recognizedPlate, 'timestamp': DateTime.now().toString(), 'registered': _firstName != null});
    await prefs.setString(key, data);
    _showSnackBar('Plate saved');

    // Navigate to the Report Screen after saving
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportScreen(apiKey: apiKey, serverIp: serverIp, username: widget.username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SmartPark',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _downloadDatabase,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfigurationScreen()),
              );
              _initializeConfiguration();
            },
          ),
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportScreen(apiKey: apiKey, serverIp: serverIp, username: widget.username)),
              );
            },
          ),
        ],
      ),
      body: _cameraController != null && _cameraController!.value.isInitialized
          ? Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onScaleStart: _handleScaleStart,
                    onScaleUpdate: _handleScaleUpdate,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.yellow,
                        width: 10,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ),
                        onPressed: _toggleFlash,
                      ),
                      IconButton(
                        icon: Icon(
                          _isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                          color: Colors.white,
                        ),
                        onPressed: _toggleCamera,
                      ),
                      Slider(
                        value: _zoomLevel,
                        min: _minZoom,
                        max: _maxZoom,
                        onChanged: (value) {
                          setState(() {
                            _zoomLevel = value;
                          });
                          _cameraController!.setZoomLevel(value);
                        },
                      ),
                    ],
                  ),
                ),
                if (_recognizedPlate != null)
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.yellow,
                          child: Row(
                            children: [
                              Text(
                                _recognizedPlate!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _savePlate,
                                child: Text('Save'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_firstName != null && _lastName != null)
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.yellow,
                            child: Text(
                              '$_firstName $_lastName',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        if (_phone != null)
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.yellow,
                            child: Text(
                              _phone!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        if (_groups != null)
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.yellow,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _groups!.map((group) {
                                return Text(
                                  group,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class ConfigurationScreen extends StatefulWidget {
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  final TextEditingController _serverIpController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _recognitionRegexController = TextEditingController();
  final TextEditingController _recognitionTimeoutController = TextEditingController();
  final TextEditingController _plateUpdateIntervalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _serverIpController.text = prefs.getString('serverIp') ?? 'aroaero.com/license_plates_php/api.php';
      _apiKeyController.text = prefs.getString('apiKey') ?? 'X9gP4L7sH2J8kQ0wB5mN3dV6tYzR1aW';
      _recognitionRegexController.text = prefs.getString('recognitionRegex') ?? r'^(?:[POCM] ?)?\d{3}[BCDFGHJKLMNPQRSTVWXYZ]{3}$';
      _recognitionTimeoutController.text = prefs.getString('recognitionTimeout') ?? '30'; 
      _plateUpdateIntervalController.text = prefs.getString('plateUpdateInterval') ?? '10';
    });
  }

  Future<void> _saveConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('serverIp', _serverIpController.text);
    await prefs.setString('apiKey', _apiKeyController.text);
    await prefs.setString('recognitionRegex', _recognitionRegexController.text);
    await prefs.setString('recognitionTimeout', _recognitionTimeoutController.text);
    await prefs.setString('plateUpdateInterval', _plateUpdateIntervalController.text);
    _showSnackBar('Configuration saved');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuration'),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _serverIpController,
              decoration: InputDecoration(
                labelText: 'Server IP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _recognitionRegexController,
              decoration: InputDecoration(
                labelText: 'Recognition Regex',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _recognitionTimeoutController,
              decoration: InputDecoration(
                labelText: 'Recognition Timeout (seconds)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _plateUpdateIntervalController,
              decoration: InputDecoration(
                labelText: 'Plate Update Interval (seconds)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveConfiguration,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportScreen extends StatefulWidget {
  final String apiKey;
  final String serverIp;
  final String username;

  ReportScreen({required this.apiKey, required this.serverIp, required this.username});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late SharedPreferences _prefs;
  late List<String> _savedPlates;

  @override
  void initState() {
    super.initState();
    _loadSavedPlates();
  }

  Future<void> _loadSavedPlates() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPlates = _prefs.getKeys().where((key) => key.startsWith('plate_')).toList();
    });
  }

  void _deletePlate(String key) async {
    await _prefs.remove(key);
    _loadSavedPlates();
  }

  Future<void> _uploadTimestamp(String key) async {
    final data = json.decode(_prefs.getString(key) ?? '{}');
    final licensePlate = data['plate'];
    final timestamp = data['timestamp'];
    final username = widget.username;

    try {
      final client = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final ioClient = IOClient(client);
      final url = Uri.parse('https://${widget.serverIp}?endpoint=plate_ts&username=$username&license_plate=$licensePlate&timestamp=$timestamp');
      print('Sending upload request to: $url'); // Debugging line
      final response = await ioClient.get(url, headers: {'API-Key': widget.apiKey});
      print('Upload response status: ${response.statusCode}'); // Debugging line

      if (response.statusCode == 200) {
        _showSnackBar('Timestamp uploaded successfully');
        setState(() {
          _savedPlates = _savedPlates.where((plate) => plate != key).toList();
          data['uploaded'] = true;
          _prefs.setString(key, json.encode(data));
          _loadSavedPlates();
        });
      } else {
        print('Failed to upload timestamp. Status code: ${response.statusCode}, Body: ${response.body}');
        _showSnackBar('Failed to upload timestamp');
      }
    } catch (e) {
      print('Error: $e');
      _showSnackBar('Network error: $e');
    }
  }

  void _registerPlate(String key) {
    final data = json.decode(_prefs.getString(key) ?? '{}');
    final licensePlate = data['plate'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController firstNameController = TextEditingController();
        final TextEditingController lastNameController = TextEditingController();
        final TextEditingController phoneController = TextEditingController();

        return AlertDialog(
          title: Text('Register Plate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final firstName = firstNameController.text;
                final lastName = lastNameController.text;
                final phone = phoneController.text;
                final username = '${firstName}_$lastName';

                try {
                  final client = HttpClient()
                    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
                  final ioClient = IOClient(client);
                  final url = Uri.parse('https://${widget.serverIp}?endpoint=register&username=$username&first_name=$firstName&last_name=$lastName&phone=$phone&license_plate=$licensePlate');
                  print('Sending registration request to: $url'); // Debugging line
                  final response = await ioClient.get(url, headers: {'API-Key': widget.apiKey});
                  print('Registration response status: ${response.statusCode}, Body: ${response.body}'); // Debugging line

                  if (response.statusCode == 200) {
                    _showSnackBar('Plate registered successfully');
                    setState(() {
                      data['registered'] = true;
                      _prefs.setString(key, json.encode(data));
                      _loadSavedPlates();
                    });
                    Navigator.of(context).pop();
                  } else {
                    print('Failed to register plate. Status code: ${response.statusCode}, Body: ${response.body}');
                    _showSnackBar('Failed to register plate');
                  }
                } catch (e) {
                  print('Error: $e');
                  _showSnackBar('Network error: $e');
                }
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        backgroundColor: Colors.yellow,
      ),
      body: ListView.builder(
        itemCount: _savedPlates.length,
        itemBuilder: (context, index) {
          final key = _savedPlates[index];
          final data = json.decode(_prefs.getString(key) ?? '{}');
          final plate = data['plate'];
          final timestamp = data['timestamp'];
          final uploaded = data['uploaded'] ?? false;
          final registered = data['registered'] ?? false;

          return ListTile(
            title: Text(plate),
            subtitle: Text(timestamp),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!uploaded)
                  IconButton(
                    icon: Icon(Icons.upload),
                    onPressed: () => _uploadTimestamp(key),
                  ),
                if (!registered)
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _registerPlate(key),
                  ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deletePlate(key),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
