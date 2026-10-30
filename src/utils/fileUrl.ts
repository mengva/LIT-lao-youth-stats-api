const MIN_PATH_LENGTH = 5;

export const getPhotoPath = (file: Express.Multer.File | undefined): string | null => {
  try {
    let path: string | undefined = file?.path;
    if (!path || path.length <= MIN_PATH_LENGTH) {
      return null;
    }
    path = path.split("uploads").pop();
    return path ?? null;
  } catch {
    return null;
  }
};

export function getFileUrl(req: any): string | null {
  const file = req.file?.filename;
  if (!file) {
    return null;
  }

  const directory = req.file.destination.split("uploads/").pop() || "";
  return `${req.protocol}://${req.headers.host}/${directory}/${file}`;
}
