
(** Compute stats on dirvish vaults and images.
  
    This library helps to analyze a dirvish installation. In particular it helps to:
    {ul
      {- list vaults}
      {- list images of a vaults}
      {- compute size and timestamp of a specific image}}
  
    Since dirvish use hardlink to copy data, the size of 2 images should be less
    than the addition of size of each one.

    @author Sylvain Le Gall
    @see <http://www.dirvish.org/> Dirvish website
  *)

type filename = string
type vault
type image
type byte = int64

(** Some basic operations of DirvishStats. Use {!default} for normal operation.
  *)
type ctxt = 
    {
      master_fn: filename;
      read: filename -> string;
      lstat: filename -> Unix.LargeFile.stats;
      readdir: filename -> filename array;
      file_exists: filename -> bool;
      is_directory: filename -> bool;
      blocksize: filename -> int;
    }

(** Standard operations for DirvishStats. This value is used by default for the
    [?ctxt] parameter.
  *)
val default: ctxt

(** {2 Vault operations} *)

(** Return the list of vaults available on the system.
  *)
val list_vault: ?ctxt:ctxt -> unit -> vault list

(** Find a specific named vault on the system.
    @raise Not_found if we can find the vault on the sytem.
  *)
val find_vault: ?ctxt:ctxt -> string -> vault

(** Return the name of a vault.
  *)
val name_of_vault: vault -> string

(** Return a human readable name for the vault.
  *)
val string_of_vault: vault -> string

(** Return the directory where the vault is stored.
  *)
val dirname_of_vault: vault -> filename

(** {2 Image operations} *)

(** Return the list of images available in a vault. *)
val list_image: vault -> image list

(** Return the latest image available in a vault.
    @raise Not_found if there are no images.
 *)
val latest_image: vault -> image

(** Find a specific image in a vault.
    @raise Not_found if the specific image cannot be found.
  *)
val find_image: vault -> string -> image

(** Return the size used on disk to store the image.
  *)
val size_of_image: image -> byte

(** Return the difference of size between two images.
  *)
val diff_size_of_images: image -> image -> byte

(** Return the reference image of an image.
    @raise Not_found if there is no reference image.
  *)
val reference_of_image: vault -> image -> image

(** Return the timestamp of the image. The timestamp is a direct translation of
    the date found in {i vault/image/dirvish/default.hist}. Local time is assumed.
  *)
val timestamp_of_image: image -> float
  
(** Return the name of the image.
  *)
val name_of_image: image -> string

(** Return a human readable name for the image.
  *)
val string_of_image: image -> string

(** Return the directory where the image is stored.
  *)
val dirname_of_image: image -> filename

