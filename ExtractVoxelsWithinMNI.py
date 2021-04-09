from nilearn import image
import numpy as np


def nifti_to_txt(filename_nii, filename_txt="auto"):
    """
    Extracts possible coordinates from a NiFTI template and saves them as a .txt file.
    """
    # Read template image
    img = image.load_img(filename_nii)
    # Extract gray matter voxels
    dat = img.get_fdata()
    x, y, z = np.where(dat == 1.0)
    # Convert to MNI space
    affine = img.affine
    within_mni = image.coord_transform(x=x, y=y, z=z, affine=affine)
    within_mni = np.array(within_mni).T
    # Create automatic output filename
    if filename_txt == "auto":
        basename_nii = path.basename(filename_nii)
        basename_txt = "within_" + basename_txt
        filename_txt = filename_nii.replace(basename_nii, basename_txt)
    # Save possible MNI coordinates
    _ = np.savetxt(filename_txt, within_mni, fmt="%i")
    return within_mni


# Apply to the default MNI152 template shipped with GingerALE
# This can be extracted from the GingerALE.jar file under 
# GingerALE/org/brainmap/image/MNI152_wb.nii
within_mni152 = nifti_to_txt(
    filename_nii="templates/MNI152_wb.nii", filename_txt="within_MNI152.txt"
)
