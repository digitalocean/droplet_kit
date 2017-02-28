module DropletKit
  class Image < BaseModel
    # @!attribute id
    # @example 12345
    # @return [Fixnum] A unique number that can be used to identify and reference a specific image.
    attribute :id

    # @!attribute name
    # @example 'foo'
    # @return [String] The display name that has been given to an image. This is what is shown in the control panel and is generally a descriptive title for the image in question.
    attribute :name

    # @!attribute distribution
    # @example 'Ubuntu'
    # @return [String] This attribute describes the base distribution used for this image.
    attribute :distribution

    # @!attribute slug
    # @example 'ubuntu-16-04-x64'
    # @return [String] A uniquely identifying string that is associated with each of the DigitalOcean-provided public images. These can be used to reference a public image as an alternative to the numeric id.
    attribute :slug

    # @!attribute public
    # @example false
    # @return [Boolean] This is a boolean value that indicates whether the image in question is public or not. An image that is public is available to all accounts. A non-public image is only accessible from your account.
    attribute :public

    # @!attribute regions
    # @example [ "nyc2", "nyc2" ]
    # @return [Array<String>] This attribute is an array of the regions that the image is available in. The regions are represented by their identifying slug values.
    attribute :regions

    # @!attribute type
    # @example 'snapshot'
    # @return [String] The kind of image, describing the duration of how long the image is stored. This is either "snapshot" or "backup".
    attribute :type

    # @!attribute min_disk_size
    # @example 'snapshot'
    # @return [Fixnum] The minimum 'disk' required for a size to use this image.
    attribute :min_disk_size

    # @!attribute size_gigabytes
    # @example 2.34
    # @return [Fixnum] The size of the image in gigabytes.
    attribute :size_gigabytes

    # @!attribute created_at
    # @example '2014-11-04T22:23:02Z'
    # @return [String] A time value given in ISO8601 combined date and time format that represents when the Image was created.
    attribute :created_at
  end
end
