#!/bin/sh
# Simple Version does not use notifications

command_exists () {
    type "$1" &> /dev/null ;
}
rmv () {
	if [ -f $1 ]
	then 
	    rm -f $1
	fi 
}
fixLibao () {

rmv /usr/local/Library/Formula/libao.rb

cat <<EOT >> /usr/local/Library/Formula/libao.rb
class Libao < Formula
desc "Cross-platform Audio Library"
homepage "https://www.xiph.org/ao/"

url "https://git.xiph.org/?p=libao.git;a=snapshot;h=18dc25cd129a7e5a9669cbdd9b076f58063606a2;sf=tgz"
sha256 "c4a1c2caac8dff249003338e20df2b614cf59e9f5c3b33c663ef8b627a370062"
version "1.2.0-snapshot-18dc25c"

bottle do
revision 1
sha256 "159aa7704f0a3cd36bfdf659ca8ec9c399077274bff1b68aa0497fdda8b6da44" => :el_capitan
sha256 "08d568c4bed498b2920983d9b848213779164c15489c82cc61429533337d19f5" => :yosemite
sha256 "81b1d6c5d1920092fba0470db2840414eb99bba8ec63d6d22800e79090db8e4b" => :mavericks
sha256 "21aa15e92c5577a4a610de8fbb3f5a72638a0c37a40c4ebebc14826359932efa" => :mountain_lion
end

depends_on "pkg-config" => :build

depends_on "automake" => :build
depends_on "autoconf" => :build
depends_on "libtool" => :build

def install
system "AUTOMAKE_FLAGS=--include-deps ./autogen.sh"
system "./configure", "--disable-dependency-tracking",
                      "--prefix=#{prefix}",
                      "--enable-static"
system "make", "install"
end
end
EOT

brew remove libao >/dev/null
brew install libao >/dev/null

}

if command_exists pianobar; then
    #Pianobar is fine so we do nothing and continue script
    echo "Pianobar exists: Awesome..."
else 
	if command_exists brew; then
		#Pianobar is not available but brew is so 

		echo "Installing Pianobar"
		brew install pianobar
		echo "Pianobar Installed Successfully"

	else
		#Neither Pianobar or Brew is installed so install both despite making the proccess longer
		
		echo "Installing Homebrew"
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		echo "Homebrew Installed Successfully"

		echo "Installing Pianobar"
		brew install pianobar
		echo "Pianobar Installed Successfully"

	fi
fi

if command_exists pianobar; then
	#Pianobar is fine so keep going 
	
	echo "If you have never run this program before please run this. Only not fix warnings if you know what you are doing!"
	
	read -p "Do you want to fix audio warnings (Y/n)?" answer
	case ${answer:0:1} in
	    "n"|"N")

	        echo "Not going to fix audio warnings..."

	    ;;
	    *)

			echo "Fixing audio Warnings..."
	        fixLibao
	        echo "Audio Warnings Fixed..."

	    ;;
	esac

else

	echo "Something went wrong now exiting..."
	echo "Check if Pianobar is Installed."

	exit 1

fi

cd ~/.config
mkdir pianobar
cd pianobar

printf "\n The autostart station can be found by either: \n * Running pianobar pressing 's' to change the station to the station you would like to auto start.\n * Then note the number that shows next to said station. \n\n OR \n\n By going into the web player select the station you would like to autostart \n * note the numbers at the end of the URL?\n"
read -p "Do you have an autostart station ready (y/N)" answer
case ${answer:0:1} in
    "y"|"Y")
        echo "Please enter the autostart station you have prepared: "
		read autostart
    ;;
    *)
        echo "Default Autostart Station will be applied"
        autostart="814524665525141882"
    ;;
esac
echo "Please enter user name for pandora (For Auto-login): "
read username
echo "Please Enter pandora password (For Auto-Login): "
read password

rmv config
cat <<EOT >> config
user = ${username}
password = ${password}
autostart_station = ${autostart}
format_nowplaying_song = "[92m%t[0m", by: "[96m%a[0m" on the album: "[93m%l[0m"[91m%r[0m%@%s
format_nowplaying_station = Station "[95m%n[0m" [90m(%i)[0m
format_list_song = %i) %a - [92m%t[0m%r
format_msg_info = [97m(i) [0m%s
format_msg_nowplaying = [36m|>[0m  %s
format_msg_time = [90m#   [97m%s[0m
format_msg_err = [90m/!\[0m %s
format_msg_question = [97m[?][0m %s
format_msg_debug = [90m%s[0m
EOT
