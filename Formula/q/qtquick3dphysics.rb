class Qtquick3dphysics < Formula
  desc "High-level QML module adding physical simulation capabilities to Qt Quick 3D"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtquick3dphysics-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtquick3dphysics-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtquick3dphysics-everywhere-src-6.12.0.tar.xz"
  sha256 "8ddb23147e4677c759d36a65ae50f6b0d0d79fa8590ac89576b91f572918b481"
  license all_of: [
    "GPL-3.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } }, # cooker
    "BSD-3-Clause", # bundled PhysX; *.cmake
  ]
  revision 1
  compatibility_version 1
  head "https://code.qt.io/qt/qtquick3dphysics.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/qtquick3dphysics-6.12.0_1"
    rebuild 1
    sha256 cellar: :any, sonoma: "9b9c4006caffc3f263602bad5145373c1d7e740dd967a062fddac90b096c5a30"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtquick3d"

  on_macos do
    depends_on "qtshadertools"
  end

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    # https://github.com/qt/qtquick3dphysics/blob/dev/examples/quick3dphysics/simple/main.qml
    (testpath/"test.qml").write <<~QML
      import QtQuick
      import QtQuick3D
      import QtQuick3D.Helpers
      import QtQuick3D.Physics

      Window {
        width: 640
        height: 480
        visible: true

        PhysicsWorld {
          scene: viewport.scene
        }
        View3D {
          id: viewport
          anchors.fill: parent
          environment: SceneEnvironment {
            clearColor: "#d6dbdf"
            backgroundMode: SceneEnvironment.Color
          }
          PerspectiveCamera {
            position: Qt.vector3d(-200, 100, 500)
            eulerRotation: Qt.vector3d(-20, -20, 0)
            clipFar: 5000
            clipNear: 1
          }
          DirectionalLight {
            eulerRotation.x: -45
            eulerRotation.y: 45
            castsShadow: true
            brightness: 1
            shadowFactor: 50
          }
          StaticRigidBody {
            position: Qt.vector3d(0, -100, 0)
            eulerRotation: Qt.vector3d(-90, 0, 0)
            collisionShapes: PlaneShape {}
            Model {
              source: "#Rectangle"
              scale: Qt.vector3d(10, 10, 1)
              materials: PrincipledMaterial {
                baseColor: "green"
              }
              castsShadows: false
              receivesShadows: true
            }
          }
          DynamicRigidBody {
            position: Qt.vector3d(-100, 100, 0)
            collisionShapes: BoxShape {
              id: boxShape
            }
            Model {
              source: "#Cube"
              materials: PrincipledMaterial {
                baseColor: "yellow"
              }
            }
          }
        }
        Timer {
          interval: 2000
          running: true
          onTriggered: Qt.quit()
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal"
    system formula_opt_bin("qtdeclarative")/"qml", "test.qml"
  end
end
