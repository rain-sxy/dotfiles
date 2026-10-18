if [ $# -eq 0 ]; then
  echo "usage: $0 -i /path/to/image"
  exit 1
fi

while getopts ":i:" opt; do
  case ${opt} in
  i)
    IMAGE_PATH="$OPTARG"
    ;;
  \?)
    echo "Invalid option: -$OPTARG" 1>&2
    exit 1
    ;;
  :)
    echo "Option -$OPTARG requires an argument." 1>&2
    exit 1
    ;;
  esac
done

if [ ! -f "$IMAGE_PATH" ]; then
  echo "Error: File '$IMAGE_PATH' does not exist."
  exit 1
fi

feh --bg-fill "$IMAGE_PATH"
matugen image "$IMAGE_PATH" --source-color-index 0
