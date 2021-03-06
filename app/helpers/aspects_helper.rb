#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

module AspectsHelper
  def link_for_aspect( aspect )
    link_to aspect.name, aspect
  end

  def remove_link( aspect )
    if aspect.people.size == 0
      link_to I18n.t('aspects.helper.remove'), aspect, :method => :delete, :confirm => "Are you sure you want to delete this aspect?"
    else
      "<span class='grey' title=#{I18n.t('aspects.helper.aspect_not_empty')}>#{I18n.t('aspects.helper.remove')}</span>"
    end
  end

  def aspect_id(aspect)
    if aspect.class == Aspect
      aspect.id
    else
      :all
    end
  end
end
